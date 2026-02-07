# Jenkins

## Auto-Detected Metadata

✅ **Repository** - From `GIT_URL` (normalized)  
✅ **Git SHA** - From `GIT_COMMIT`  
✅ **Git Branch** - From `GIT_BRANCH`  
✅ **Build Number** - From `BUILD_NUMBER`  
✅ **Build URL** - From `BUILD_URL`  
⚠️ **User** - From `BUILD_USER` (requires [Build User Vars Plugin](https://plugins.jenkins.io/build-user-vars-plugin/))  
⚠️ **User Email** - From `BUILD_USER_EMAIL` (requires plugin)  
✅ **Product Name** - Extracted from repository URL (if not specified)  
✅ **Version** - Uses build number as fallback (if not specified)

!!! warning "User Information Requires Plugin"
    To auto-detect the user who triggered the build, install the [Build User Vars Plugin](https://plugins.jenkins.io/build-user-vars-plugin/). Without it, you'll need to specify `--built-by` or `--deployed-by` manually.

## Installation

Add a setup stage to download the CLI:

```groovy
stage('Setup') {
    steps {
        sh '''
            curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
            chmod +x /usr/local/bin/versioner
        '''
    }
}
```

## Track Build

```groovy
pipeline {
    agent any
    
    stages {
        stage('Setup') {
            steps {
                sh '''
                    curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
                    chmod +x /usr/local/bin/versioner
                '''
            }
        }
        
        stage('Build') {
            steps {
                sh 'make build'
                sh '''
                    versioner track build \
                      --product=my-api \
                      --status=completed
                '''
            }
        }
    }
}
```

## Track Deployment

```groovy
pipeline {
    agent any
    
    stages {
        stage('Setup') {
            steps {
                sh '''
                    curl -L https://github.com/versioner-io/versioner-cli/releases/latest/download/versioner-linux-amd64 -o /usr/local/bin/versioner
                    chmod +x /usr/local/bin/versioner
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                sh './deploy.sh production'
                sh '''
                    versioner track deployment \
                      --product=my-api \
                      --environment=production \
                      --version=${BUILD_NUMBER} \
                      --status=completed
                '''
            }
        }
    }
    
    post {
        failure {
            sh '''
                versioner track deployment \
                  --product=my-api \
                  --environment=production \
                  --version=${BUILD_NUMBER} \
                  --status=failed
            '''
        }
    }
}
```

## Next Steps

- [CLI Usage Guide](../usage.md)
- [CI/CD Integration Overview](index.md)
