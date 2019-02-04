from google.appengine.ext import ndb

class Period (ndb.Model):
    name = ndb.StringProperty(required=True)
    start = ndb.IntegerProperty(required=False)
    end = ndb.IntegerProperty(required=False)

class Nation (ndb.Model):
    name = ndb.StringProperty(required=True)
    flag = ndb.StringProperty(required=True)


class Tank (ndb.Model):
    name = ndb.StringProperty(required=True)
    description = ndb.StringProperty(required=False)
    photos = ndb.StringProperty(required=False,repeated=True)
    nation = ndb.KeyProperty(Nation, required=True)
    period = ndb.KeyProperty(Period, required=False)
