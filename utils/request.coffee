http = require("http")
https = require("https")
HttpError = require('error/index').HttpError

exports.getJSON = (options, onResult)->
  prot = options.port == 443 ? https : http;
  req = https.request(options, (res)->
    output = '';
    console.log(options.host + ':' + res.statusCode);
    res.setEncoding('utf8');

    res.on('data', (chunk) ->
      output += chunk;
    )

    res.on('end', ()->
      obj = JSON.parse(output)
      onResult(res.statusCode, obj)
    )
  )

  req.on('error', (err)->
    throw new HttpError("Error while request: #{err}")
  )
  req.end()