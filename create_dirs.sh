#!/opt/homebrew/bin/bash
version="1.0"

LOG_DIR=0
SRC_DIR=1
MAIN_APP=1
DATA_DIR=1
GIT_URL=""
PROJECT_NAME=
RQR_CONDITION=0
GIT_CONDITION=0
README_CONDITION=0

while test $# -gt 0; do
    case "${1}" in
        -l | --log)
            LOG_DIR=1 ;;
        -rq | --requirement)
            RQR_CONDITION=1;;
        -rd | --readme)
            README_CONDITION=1;;
        -g | --git)
            GIT_CONDITION=1;
            [[ "${2:0:1}" != "-" ]] && GIT_URL="$2" && shift;;
        -n | --name)
            if [[ "${2:0:1}" != "-" && -n "$2" ]]; then PROJECT_NAME="$2"; shift; 
            else printf "%s must have a value\n\n" "${1}" >&2 && exit 1;fi;;
        *)
            echo "$1 is not a recognized flag!"
            # usage
            exit 1;
        #     ;;
    esac
    shift
done

if [[ -z ${PROJECT_NAME} ]]; then 
    printf "A project name is needed via -n/--name!\n\n" >&2 && exit 1
else
    mkdir -p ${PROJECT_NAME}
fi

if [[ -n ${GIT_URL} ]]; then 
    git clone ${GIT_URL} ${PROJECT_NAME}
    BASE=$(basename -s .git ${GIT_URL})
    PROJECT_NAME=${PROJECT_NAME}/${BASE}
fi

[[ "${README_CONDITION}" -eq 1 ]] &&  touch ${PROJECT_NAME}/README.md
[[ "${RQR_CONDITION}" -eq 1 ]] && touch ${PROJECT_NAME}/requirements.txt
[[ "${LOG_DIR}" -eq 1 ]] && mkdir -p ${PROJECT_NAME}/logs/{prediction,training}

mkdir -p ${PROJECT_NAME}/data/{raw,final,excluded}
mkdir -p ${PROJECT_NAME}/analysis/{results,analysis_utils}
mkdir -p ${PROJECT_NAME}/scripts/{core,models,preprocessing,dataloader}
mkdir -p ${PROJECT_NAME}/results/{training,prediction}


if [[ "${GIT_CONDITION}" -eq 1 && -z ${GIT_URL} ]]; then 
    cd ${PROJECT_NAME}; git init; touch .gitignore;
fi