#
## Aliases
#

u : up

d : down
h : help
l : logs
s : stop
sh : shell
upd : up-daemon


#
## Rules
#

clean : 	### Purge everything linked to this project
 	# This will erase your databases and remove Docker data for good.
	# Recovery won't be possible at all!
	@docker-compose down
	@rm -rf ./.data/.pgdata'

down :		### (Alias=d) Down containers
	@docker-compose down

help :		### (Current) (Alias=h) See all available commands
	@fgrep -h "###" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/###//'

logs :		### (Alias=l) Display logs
	@docker-compose logs -f

purge : 	### Purge everything linked to this project
 	# This will erase your databases and remove Docker data for good.
	# Recovery won't be possible at all!
	@docker-compose down --rmi all -v
	@rm -rf ./.data/.pgdata'

shell:		#x## (Alias=sh) Access to db via shell
	@docker exec -ti sqlquerying_db psql -U postgres

stop :		### (Alias=s) Stop containers
	@docker-compose stop

up : 		### (Default) (Alias=u) Up containers
	@docker-compose up

up-daemon :	### (Alias=upd) Up containers as a daemon
	@docker-compose up -d

.PHONY: clean down help logs purge shell stop up up-daemon
