# .bashrc file
# Sebastien LEGRAND - September 2011

#
# VARS
#

# profile.conf directory
PRF_DIR=~/.bashrc.d

# comment & empty line patter
PATTERN="^#|^$"

#
# FUNCTIONS
#

# read a "path" file
_readPathFile()
{
  if [ -f $1 ]; then
      local MY_PATH=""
      while read LINE
      do
          # bypass empty line and comments
          [[ ${LINE} =~ ${PATTERN} ]] && continue

          # pass if directory does not exist
          [ ! -d ${LINE} ] && continue

          # add the directory to the current var
          if [ -z ${MY_PATH} ]; then
              MY_PATH=${LINE}
          else
              MY_PATH=${MY_PATH}:${LINE}
          fi
      done < $1
      echo ${MY_PATH}
  else
      echo ""
  fi
}

#
# BEGIN
#

# load custom functions
if [ -f ${PRF_DIR}/functions ]; then
  . ${PRF_DIR}/functions
fi

# aliases
if [ -f ${PRF_DIR}/aliases ]; then
  while read LINE
  do
    # bypass empty lines and comments
    [[ ${LINE} =~ ${PATTERN} ]] && continue

    ALIAS=`echo $LINE | cut -d: -f1`
    CMD=`echo $LINE | cut -d: -f2`
    if [ "$ALIAS" != "" ] && [ "$CMD" != "" ]; then
      alias ${ALIAS}="${CMD}"
    fi
  done < ${PRF_DIR}/aliases
else
  echo "${PRF_DIR}/aliases not found."
fi

# environment variables
if [ -f ${PRF_DIR}/env ]; then
  source ${PRF_DIR}/env

  # export automatically all defined vars
  VARS=`cat ${PRF_DIR}/env | grep -v '^#' | grep '=' | sed -e 's/^\(.*\)=.*/\1/' | xargs`
  export ${VARS}
fi

# PATH / LD_LIBRARY_PATH / MANPATH variables
PATH=`_readPathFile ${PRF_DIR}/path`
LD_LIBRARY_PATH=`_readPathFile ${PRF_DIR}/ld_path`
MANPATH=`_readPathFile ${PRF_DIR}/man_path`
export PATH LD_LIBRARY_PATH MANPATH

# auto-completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

if [ -f ${PRF_DIR}/completion ]; then
  . ${PRF_DIR}/completion
fi


