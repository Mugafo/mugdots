export PATH="$HOME/bin:$PATH"
export GPG_TTY=$(tty)

for file in ~/.{extra,bashrc,bash_prompt,exports,aliases,functions}; do
	[ -r "$file" ] && source "$file"
done
unset file

SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

source <(kubectl completion bash)
source <(kubectl completion bash | sed 's/kubectl/k/g')
#source <(kubectl completion bash | sed 's/k edit deployment/ked/g')
#source <(kubectl completion bash | sed 's/k edit cronjob/kec/g')
#source <(kubectl completion bash | sed 's/k delete pod/kdp/g')
#source <(kubectl completion bash | sed 's/k delete job/kdj/g') 

if [ -f /usr/share/bash-completion/completions/git ]; then
  source /usr/share/bash-completion/completions/git

  __git_complete co _git_checkout
fi

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
