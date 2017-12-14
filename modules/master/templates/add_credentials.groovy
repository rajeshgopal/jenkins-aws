import java.lang.System
import jenkins.*
import hudson.model.*
import jenkins.model.*
// Plugins for SSH credentials
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*

global_domain = Domain.global()
credentials_store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

<% @input.each do |value| %>
cred = new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,'<%= value['credentialid'] %>','<%= value['description'] %>','<%= value['userid'] %>','<%= value['password'] %>')
credentials_store.addCredentials(global_domain, cred)
<% end %>
