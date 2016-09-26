local args = ngx.req.get_uri_args()
local g_recaptcha_response = args['g-recaptcha-response']
if g_recaptcha_response == nil or g_recaptcha_response == "" then
	ngx.exit(403)
end

if verify_recaptcha(g_recaptcha_response) == false then
	ngx.exit(403)
end

ngx.redirect(ngx.var.http_referer)