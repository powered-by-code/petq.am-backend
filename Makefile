FRONTEND_REPO_URL = git@github.com:powered-by-code/haykakan-tsarayutyun-katalog.git


pull-frontend:
	rm -rf frontend
	git clone $(FRONTEND_REPO_URL) frontend
	cd frontend && touch .env && \
		echo "VITE_API_URL=https://petq.am" >> .env && \
		echo VITE_GOOGLE_MAPS_API_KEY=AIzaSyCBoGOPqUUpogNny10_2Z7GL91E3XDCtAM >> .env

build-frontend:
	cd frontend && \
		docker build -t petq.am:latest .
	
pull-and-build-frontend: pull-frontend build-frontend


backend-envs:
	cp directus/.env.example directus/.env && \
	sed -i 's|PUBLIC_URL=.*|PUBLIC_URL="https://api.petq.am "|g' directus/.env
	
up-prod:
	docker compose -f docker-compose.prod.yml up -d


deploy-prod:
	ssh instepanavan "cd ./petq.am-backend && make deploy"

deploy: pull-and-build-frontend backend-envs up-prod