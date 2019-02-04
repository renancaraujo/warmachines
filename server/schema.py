from google.appengine.ext import ndb
import graphene
from graphene_gae import NdbObjectType, NdbConnectionField

from models.model import Period as PeriodModel
from models.model import Nation as NationModel
from models.model import Tank as TankModel

class Tank(NdbObjectType):
    class Meta:
        model = TankModel

class Period(NdbObjectType):
    class Meta:
        model = PeriodModel

    tanks = NdbConnectionField(Tank)

    def resolve_tanks(self, info, **args):
        return TankModel.query().filter(TankModel.period == self.key)

class Nation(NdbObjectType):
    class Meta:
        model = NationModel

    tanks = NdbConnectionField(Tank)

    def resolve_tanks(self, info, **args):
        return TankModel.query().filter(TankModel.nation == self.key)

    

class Query(graphene.ObjectType):
    def __str__(self):
        "eita"


schema = graphene.Schema(query=Query)