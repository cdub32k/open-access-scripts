npm run build-dev --prefix open-access-frontend
mv open-access-frontend/dist/index.html open-access-backend

for file in open-access-frontend/dist/*
do
curl --data "@$file" \
     --include \
     --request PUT \
     --header "AccessKey: bbdfe5a1-2853-488b-9857e9d09f58-d2ae-4331" \
  "https://storage.bunnycdn.com/open-access-dev/$(basename $file)"
done;

for asset in open-access-frontend/dist/assets/*
do
curl --data-binary "@$asset" \
     --include \
     --request PUT \
     --header "AccessKey: bbdfe5a1-2853-488b-9857e9d09f58-d2ae-4331" \
  "https://storage.bunnycdn.com/open-access-dev/assets/$(basename $asset)"
done;

git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend checkout dev 
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend add index.html
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend commit -m "server build"
git --git-dir=./open-access-backend/.git --work-tree=./open-access-backend push origin dev