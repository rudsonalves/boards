docker_up:
	docker compose up -d

docker_down:
	docker compose down

flutter_clean:
	flutter clean && flutter pub get

diff:
	git add .
	git diff --cached > ~/diff

push:
	git add .
	git commit -F ~/commit.txt
	git push origin HEAD
	git checkout main

build_profile:
	flutter clean
	flutter pub get
	flutter run --profile

firebase_emu_with_go:
	bash go-tests/start-go-functions.sh

firebase_emu_stop:
	bash go-tests/stop-go-functions.sh

go_functions_deploy:
	cd go-functions && gcloud functions deploy $(FUNC_NAME) --runtime go122 --trigger-http --allow-unauthenticated

firebase_emu:
	firebase emulators:start --import=./emulator_data

# firebase_emu_debug:
# 	firebase emulators:start --import=./emulator_data --debug

firebase_emusavecache:
	firebase emulators:export ./emulator_data -f

deploy_functions:
	firebase deploy --only functions

ngrok_tunnel:
	ngrok config add-authtoken 2qMT4XFwP43IDKOFa46jntSukLk_64g7SdmbmBSBjUJyrKt3B && ngrok http 5001

# Do a `stripe login' every 90 days
stripe_login:
	stripe login

stripe_listen_webhook:
	stripe listen --forward-to http://127.0.0.1:5001/boards-fc3e5/southamerica-east1/stripeWebhook

lint_functions:
	cd functions/ && npm run lint
