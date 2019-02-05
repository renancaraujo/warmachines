from google.appengine.ext import ndb
import graphene
from graphene_gae import NdbObjectType

from models.model import Period as PeriodModel
from models.model import Nation as NationModel
from models.model import Tank as TankModel

class Tank(NdbObjectType):
    class Meta:
        model = TankModel

class Period(NdbObjectType):
    class Meta:
        model = PeriodModel

    tanks = graphene.List(Tank)

    def resolve_tanks(self, info, **args):
        return TankModel.query().filter(TankModel.period == self.key)

class Nation(NdbObjectType):
    class Meta:
        model = NationModel

    tanks = graphene.List(Tank)

    def resolve_tanks(self, info, **args):
         return TankModel.query().filter(TankModel.nation == self.key)


class Query(graphene.ObjectType):
    nations = graphene.List(Nation)
    tank = graphene.Field(Tank)

    def resolve_nations(self, info, **args):
        return NationModel.query()

    def resolve_tank(self, info, id):
        return TankModel.get_by_id(id)


schema = graphene.Schema(query=Query)