npm run build --prefix open-access-frontend
mv open-access-frontend/dist/index.html open-access-backend

aws s3 sync ../open-access-frontend/dist s3://open-access-network/app --acl "public-read" --exclude "*" --include "*.js" --content-encoding gzip
aws s3 sync ../open-access-frontend/dist s3://open-access-network/app --acl "public-read" --exclude "*" --include "*.css" --content-encoding gzip
aws s3 sync ../open-access-frontend/dist s3://open-access-network/app --acl "public-read" --exclude "*" --include "favicon.ico"

aws s3 sync ../open-access-frontend/dist/assets s3://open-access-network/app/assets --acl "public-read"

git --git-dir=../open-access-backend/.git --work-tree=../open-access-backend checkout master 
git --git-dir=../open-access-backend/.git --work-tree=../open-access-backend add index.html
git --git-dir=../open-access-backend/.git --work-tree=../open-access-backend commit -m "server build"
git --git-dir=../open-access-backend/.git --work-tree=../open-access-backend push origin master
