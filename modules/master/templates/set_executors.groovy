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

def j = Jenkins.getInstance()
    j.setNumExecutors(<%= @input['count'] %>)
    j.save()
