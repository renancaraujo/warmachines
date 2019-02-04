from flask import Flask
from flask_graphql import GraphQLView
from schema import schema
app = Flask(__name__, static_folder="static", static_url_path='')


app.add_url_rule('/graphql', view_func=GraphQLView.as_view('graphql', schema=schema, graphiql=True))
