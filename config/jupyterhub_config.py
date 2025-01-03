# Configuration file for jupyterhub.

c = get_config() 
c.JupyterHub.authenticator_class = 'pam'
c.Authenticator.allowed_users = {'atrawog'}
c.Spawner.default_url = '/lab'
c.JupyterHub.bind_url = 'http://:8000'
c.Spawner.notebook_dir = '/workspace/book'
c.JupyterHub.cookie_secret_file = '/workspace/jupyterhub_cookie.secret'
c.Spawner.args = ['--NotebookApp.token=""', '--NotebookApp.disable_check_xsrf=True']
c.NotebookApp.allow_origin = '*'
c.NotebookApp.disable_check_xsrf = True
c.JupyterHub.log_level = 'DEBUG'
c.Spawner.debug = True
c.Spawner.args = [
    '--NotebookApp.cookie_secret_file=/workspace/jupyterhub_cookie.secret'
]
c.LabApp.disable_check_for_updates = True
# Set the path for the SQLite database
c.JupyterHub.db_url = 'sqlite:////workspace/_jupyter/jupyterhub.sqlite'

# Set the path for the proxy PID file
c.ConfigurableHTTPProxy.pid_file = '/workspace/_jupyter/jupyterhub-proxy.pid'

# Set the path for the cookie secret file
c.JupyterHub.cookie_secret_file = '/workspace/_jupyter/jupyterhub_cookie.secret'
