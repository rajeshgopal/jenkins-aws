import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
<% @input.each do |value| %>
 hudsonRealm.createAccount("<%= value['user'] %> ","<%= value['passwd'] %>")
<% end %>
instance.setSecurityRealm(hudsonRealm)
instance.save()
