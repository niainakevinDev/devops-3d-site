FROM nginx:alpine

LABEL maintainer="DevOps Training"
LABEL project="DevOps 3D CI/CD"

# Supprimer la page par défaut
RUN rm -rf /usr/share/nginx/html/*

# Copier le mini-site
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
