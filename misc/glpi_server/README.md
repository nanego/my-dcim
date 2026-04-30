## Setup

#### 1) Launch Docker containers

```bash
docker compose up -d
```

#### 2) Log in

Visit `localhost:8085` and log in with username: `glpi`, password: `glpi`.  
Note: The application initializes the database on startup. If you see a `Connection Reset` error, please wait about 20 seconds and try again.

#### 3) Enable the API

In the [settings](http://localhost:8085/front/config.form.php), navigate to the `API` tab, check `Enable legacy REST API`, and click Save.  
You must then add a client using your IP address (host machine) and copy the `app token`.

#### 4) Create a user_token

On the [users page](http://localhost:8085/front/user.php), click on the `glpi` user. At the bottom of the page, locate the `API token` field.  
Check "Regenerate" and then click Save. You now have your `user_token`.
