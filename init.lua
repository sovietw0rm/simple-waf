recaptcha_pubkey = "xxx"
recaptcha_secret = "xxx"
recaptcha_html = string.gsub(io.open('/vnsec-waf/static/recaptcha.html', 'r'):read('*all'), '(recaptcha_pubkey)', recaptcha_pubkey)

local http = require "resty.http"
cjson = require 'cjson'

function verify_recaptcha(g_recaptcha_response)
	local httpclient = http.new()
    local body = "secret=" .. recaptcha_secret .. "&response=" .. g_recaptcha_response
    local res, err = httpclient:request_uri("https://www.google.com/recaptcha/api/siteverify",
 	{
 		method = "POST", 
 		body = body, 
 		ssl_verify = "no"
 	})

    if not res then
    	ngx.log(ngx.ERR, err)
    	ngx.exit(500)
    end
    if not res.status == 200 then
    	ngx.exit(500)
    end
    local data = cjson.decode(res.body)
    return data['success']
end