// Port de functions/index.js exports.buildNewsClusters (Firebase Cloud Function -> Supabase Edge Function).
// Planifiée toutes les 6h via pg_cron, décalée pour tourner après fetch-party-news.
import { createClient } from "npm:@supabase/supabase-js@2";
import { significantWords, similarity } from "../_shared/parties.ts";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

Deno.serve(async () => {
  const threeDaysAgo = new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString();

  const { data: articles, error: readError } = await supabase
    .from("news")
    .select("id, url, title, description, source_name, published_at")
    .gte("published_at", threeDaysAgo);

  if (readError) {
    console.error("Échec lecture news:", readError.message);
    return new Response(`Erreur: ${readError.message}`, { status: 500 });
  }

  const used = new Set<string>();
  const groups: (typeof articles)[] = [];

  for (let i = 0; i < articles.length; i++) {
    if (used.has(articles[i].id)) continue;
    const base = articles[i];
    const baseWords = significantWords(base.title || "");
    const group = [base];
    used.add(base.id);

    for (let j = i + 1; j < articles.length; j++) {
      if (used.has(articles[j].id)) continue;
      const candidateWords = significantWords(articles[j].title || "");
      if (similarity(baseWords, candidateWords) >= 0.2) {
        group.push(articles[j]);
        used.add(articles[j].id);
      }
    }
    groups.push(group);
  }

  for (const group of groups) {
    // Dédupliquer par source (un même journal ne compte qu'une fois).
    const uniqueSources: { name: string; url: string }[] = [];
    const seenSources = new Set<string>();
    for (const article of group) {
      if (!seenSources.has(article.source_name)) {
        seenSources.add(article.source_name);
        uniqueSources.push({ name: article.source_name, url: article.url });
      }
    }

    // Prend la description la plus longue comme description principale.
    const mainArticle = group.reduce((a, b) =>
      (b.description?.length || 0) > (a.description?.length || 0) ? b : a
    );

    const { error } = await supabase.from("news_clusters").upsert({
      main_url: mainArticle.url,
      title: mainArticle.title,
      description: mainArticle.description,
      published_at: mainArticle.published_at,
      source_count: uniqueSources.length,
      sources: uniqueSources,
      fetched_at: new Date().toISOString(),
    }, { onConflict: "main_url" });

    if (error) console.error(`Échec upsert cluster ${mainArticle.url}:`, error.message);
  }

  return new Response(`${groups.length} sujets regroupés depuis ${articles.length} articles.`);
});
