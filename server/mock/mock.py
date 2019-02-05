from flask import request
from google.appengine.ext import ndb


from models.model import Period 
from models.model import Nation
from models.model import Tank 


def add_tank():
    content = request.get_json()
    tank_id = content.get("id")
    tank_key = ndb.Key(Tank, tank_id)
    name = content.get("name")
    description = content.get("description")
    photos = content.get("photos")

    nation_id = content.get("nation")
    nation_key = ndb.Key(Nation, nation_id)
    
    period_id = content.get("period")
    period_key = ndb.Key(Period, period_id)

    tank_key = Tank(key=tank_key, name=name, nation=nation_key, period=period_key, description=description, photos=photos).put()

    return tank_key.urlsafe()

def add_period():
    content = request.get_json()
    period_id = content.get("id")
    period_key = ndb.Key(Period, period_id)

    name = content.get("name")
    start = content.get("start")
    end = content.get("end")

    period_key = Period(key=period_key, name=name, start=start, end=end).put()

    return period_key.urlsafe()

def add_nation():
    content = request.get_json()
    nation_id = content.get("id")
    nation_key = ndb.Key(Nation, nation_id)

    name = content.get("name")
    flag = content.get("flag")

    nation_key = Nation(key=nation_key, name=name, flag=flag).put()

    return nation_key.urlsafe()