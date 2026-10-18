// Envoie une notification push OneSignal à tous les devices qui suivent un parti
// (tag `<partyId> = "true"`, posé côté app dans notifications_screen.dart).
export async function sendPartyPush(partyId: string, title: string, message: string, url: string) {
  const appId = Deno.env.get("ONESIGNAL_APP_ID");
  const restApiKey = Deno.env.get("ONESIGNAL_REST_API_KEY");
  if (!appId || !restApiKey) {
    console.error("OneSignal non configuré (ONESIGNAL_APP_ID / ONESIGNAL_REST_API_KEY manquants)");
    return;
  }

  const response = await fetch("https://onesignal.com/api/v1/notifications", {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": `Basic ${restApiKey}`,
    },
    body: JSON.stringify({
      app_id: appId,
      filters: [{ field: "tag", key: partyId, relation: "=", value: "true" }],
      headings: { fr: title },
      contents: { fr: message },
      url,
    }),
  });

  if (!response.ok) {
    console.error(`Échec envoi push OneSignal pour ${partyId}:`, await response.text());
  }
}
