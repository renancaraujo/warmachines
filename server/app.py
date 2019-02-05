from google.appengine.ext import ndb

from flask import Flask, request
from flask_graphql import GraphQLView
from schema import schema
from mock.mock import add_tank, add_period, add_nation

app = Flask(__name__, static_folder="static", static_url_path='')



app.add_url_rule('/graphql', view_func=GraphQLView.as_view('graphql', schema=schema, graphiql=True))

app.add_url_rule("/addTank", 'add_tank', add_tank, methods=['POST'])
app.add_url_rule("/addPeriod", 'add_period', add_period, methods=['POST'])
app.add_url_rule("/addNation", 'add_nation', add_nation, methods=['POST'])

