# CloudFront Function to append index.html to directory requests
resource "aws_cloudfront_function" "url_rewrite" {
  name    = "${var.project_name}-${var.environment}-url-rewrite"
  runtime = "cloudfront-js-1.0"
  comment = "Append index.html to directory requests for MkDocs"
  publish = true
  code    = <<-EOT
function handler(event) {
    var request = event.request;
    var uri = request.uri;

    if (uri.endsWith('/')) {
        request.uri += 'index.html';
        return request;
    }

    if (!uri.includes('.')) {
        return {
            statusCode: 301,
            statusDescription: 'Moved Permanently',
            headers: { location: { value: uri + '/' } }
        };
    }

    return request;
}
EOT
}
