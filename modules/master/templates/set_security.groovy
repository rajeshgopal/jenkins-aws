import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import groovy.transform.InheritConstructors
import hudson.model.*
import hudson.plugins.sshslaves.*
import hudson.util.*
import jenkins.model.*
import jenkins.security.*
import org.apache.commons.io.IOUtils
import org.jenkinsci.plugins.*

class InvalidAuthenticationStrategy extends Exception{}
@InheritConstructors
class UnsupportedCredentialsClass extends Exception {}
@InheritConstructors
class InvalidCredentialsId extends Exception {}
@InheritConstructors
class MissingRequiredPlugin extends Exception {}

def j = Jenkins.getInstance()

Set<String> agentProtocolsList = ['JNLP4-connect', 'Ping']
    if(!j.getAgentProtocols().equals(agentProtocolsList)) {
        j.setAgentProtocols(agentProtocolsList)
    }
def security_model = '<%= @input['model'] %>'
    if (security_model == 'disabled') {
      j.disableSecurity()
      return null
    }

    def strategy
    def realm
    switch (security_model) {
      case 'fullcontrol':
        strategy = new hudson.security.FullControlOnceLoggedInAuthorizationStrategy()
        realm = new hudson.security.HudsonPrivateSecurityRealm(false, false, null)
        break
      case 'unsecured':
        strategy = new hudson.security.AuthorizationStrategy.Unsecured()
        realm = new hudson.security.HudsonPrivateSecurityRealm(false, false, null)
        break
      default:
        throw new InvalidAuthenticationStrategy()
    }
    j.setAuthorizationStrategy(strategy)
    j.setSecurityRealm(realm)
    j.save()
