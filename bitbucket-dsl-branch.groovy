def generatedJobs = new DslScriptLoader(jobManagement).runScript("""
  organizationFolder('Dashboard Pipelines') {
    description('Builds all of the repositories supporting the Deployment Dashboards')
    displayName('Dashboard Generator')
    organizations {
      bitbucket {
        // Specify the name of the Bitbucket Team or Bitbucket User Account.
        repoOwner('${repoOwner}')
        // Credentials used to scan branches and check out sources
        credentialsId('folder_bitbucketuser')
        // Left blank to use Bitbucket Cloud -- This should be the id of a globally configured server
        //serverUrl('Bitbucket')
        bitbucketServerUrl('${serverUrl}')
      }      
    }

    // We need to configure this stuff by hand until JobDSL gets some support
    configure { node ->
        def traits = node / navigators / 'com.cloudbees.jenkins.plugins.bitbucket.BitbucketSCMNavigator' / traits
        traits << 'jenkins.scm.impl.trait.RegexSCMSourceFilterTrait' {
            regex('${repoRegex}')   
        }
        traits << 'com.cloudbees.jenkins.plugins.bitbucket.BranchDiscoveryTrait' {
            strategyId('1')   
        }
        traits << 'jenkins.scm.impl.trait.RegexSCMHeadFilterTrait' {
            regex('${branchRegex}')   
        }
    }    

    properties {
      folderCredentialsProperty {
         domainCredentials {
          domainCredentials {
              domain {
                name('GLOBAL')
                description('Globally available')
              }
              credentials {
                usernamePasswordCredentialsImpl {
                  scope('GLOBAL')
                  id('folder_bitbucketuser')
                  description('Bitbucket User credentials stored at the folder level.')
                  username('${bbUser}')
                  password('${bbPassword}')
                }
              }
          }
         }
      }
    }
    
  }
""")
