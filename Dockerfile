ARG __from_img=mi24a7acr.azurecr.io/msr-1015-lean-original-recipe:Fixes_24-02-12
# ARG __from_img used below on the final stage
FROM ${__from_img}

COPY ./code/is-packages/MyMailService ${SAG_HOME}/IntegrationServer/packages/MyMailService
COPY ./code/is-packages/MyNewsService ${SAG_HOME}/IntegrationServer/packages/MyNewsService
