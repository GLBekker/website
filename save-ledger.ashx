<%@ WebHandler Language="C#" Class="SaveLedger" %>
using System;
using System.IO;
using System.Text;
using System.Web;

public class SaveLedger : IHttpHandler {
    public void ProcessRequest(HttpContext context) {
        context.Response.ContentType = "application/json";
        try {
            string op = (context.Request["op"] ?? string.Empty).ToLowerInvariant();
            string baseDir = context.Server.MapPath("~/data");
            string invoicesDir = Path.Combine(baseDir, "invoices");
            Directory.CreateDirectory(invoicesDir);

            if (op == "save-invoice") {
                string body = ReadBody(context.Request);
                if (string.IsNullOrWhiteSpace(body)) throw new Exception("Empty request body");

                // Pick an id from body if present; else querystring
                string id = context.Request["id"]; // optional fallback
                // Fallback naive parse to find "id":"..." in JSON without full JSON dependency
                if (string.IsNullOrEmpty(id)) {
                    int idx = body.IndexOf("\"id\"");
                    if (idx >= 0) {
                        int colon = body.IndexOf(':', idx);
                        if (colon > 0) {
                            int q1 = body.IndexOf('"', colon + 1);
                            int q2 = q1 >= 0 ? body.IndexOf('"', q1 + 1) : -1;
                            if (q1 >= 0 && q2 > q1) id = body.Substring(q1 + 1, q2 - q1 - 1);
                        }
                    }
                }
                if (string.IsNullOrWhiteSpace(id)) throw new Exception("Missing id");
                id = SanitizeFileName(id);
                string path = Path.Combine(invoicesDir, id + ".json");
                File.WriteAllText(path, body, new UTF8Encoding(false));
                WriteOk(context, new { ok = true, saved = id });
                return;
            }
            if (op == "save-ledger") {
                string body = ReadBody(context.Request);
                if (string.IsNullOrWhiteSpace(body)) throw new Exception("Empty request body");
                string ledgerPath = Path.Combine(baseDir, "ledger.json");
                File.WriteAllText(ledgerPath, body, new UTF8Encoding(false));
                WriteOk(context, new { ok = true });
                return;
            }
            if (op == "delete-invoice") {
                string id = context.Request["id"];
                if (string.IsNullOrWhiteSpace(id)) throw new Exception("Missing id");
                id = SanitizeFileName(id);
                string path = Path.Combine(invoicesDir, id + ".json");
                if (File.Exists(path)) File.Delete(path);
                WriteOk(context, new { ok = true, deleted = id });
                return;
            }

            // Unknown op
            context.Response.StatusCode = 400;
            context.Response.Write("{\"ok\":false,\"error\":\"Unknown op\"}");
        }
        catch (Exception ex) {
            context.Response.StatusCode = 500;
            context.Response.Write("{\"ok\":false,\"error\":\"" + JsonEscape(ex.Message) + "\"}");
        }
    }

    public bool IsReusable { get { return false; } }

    private static string ReadBody(HttpRequest req) {
        using (var sr = new StreamReader(req.InputStream, req.ContentEncoding ?? Encoding.UTF8)) {
            return sr.ReadToEnd();
        }
    }

    private static string SanitizeFileName(string name) {
        foreach (char c in Path.GetInvalidFileNameChars()) name = name.Replace(c, '_');
        return name;
    }

    private static string JsonEscape(string s) {
        return (s ?? string.Empty).Replace("\\", "\\\\").Replace("\"", "\\\"");
    }
}

