import json
import logging
import boto3
import copy
import re  
from botocore.exceptions import ClientError

logger = logging.getLogger(__name__)

class Nutrition_results:
    def __init__(self, name, benchmark, cooccurrence_top_list, amount=0, benchmark_flag=1):
        self.name=str(name)
        self.amount=float(amount)
        self.percentDailyValue="67"
        self.displayValue="1"
        self.benchmark=float(benchmark)
        self.benchmark_percentage=amount/benchmark
        self.benchmark_flag=int(benchmark_flag)
        self.cooccurrence_top_list=cooccurrence_top_list
        self.unit="mg"
        self.raw_nutrition_top_list=[]
        if name == "Vitamin B6":
            self.raw_nutrition_top_list=["Milk", "Eggs", "Carrot", "Spinach", "Sweet Potato"]
        elif name == "Folate":
            self.unit="mcg"
            self.raw_nutrition_top_list=["Cereal", "Spinach", "Beans", "Asparagus", "Oranges", "Peanuts"]
        elif name == "Calcium":
            self.raw_nutrition_top_list=["Milk", "Yogurt", "Cheese", "Salmon", "Spinach"]
        elif name == "Iron":
            self.raw_nutrition_top_list=["Cereal", "Meat", "Spinach", "Beans", "Poultry"]
        elif name == "Protein":
            self.unit="g"
            self.raw_nutrition_top_list=["Cheese", "Poultry", "Fish", "Lentils", "Milk", "Eggs"]
        elif name == "Vitamin A":
            self.unit="IU"
            self.raw_nutrition_top_list=["Beef liver", "Salmon", "Cheese", "Butter"]
        elif name == "Vitamin C":
            self.raw_nutrition_top_list=["Guavas", "Kiwi", "Strawberries", "Orange", "Broccoli", "Bell Peppers", "Tomato"]

    def getDict(self):
        # return self as a dict 
        NR_dict={}
        NR_dict['name']=self.name
        NR_dict['amount']=self.amount
        NR_dict['percentDailyValue']=self.percentDailyValue
        NR_dict['displayValue']=self.displayValue
        NR_dict['unit']=self.unit
        NR_dict['benchmark']=self.benchmark
        NR_dict['benchmark_percentage']=self.benchmark_percentage
        NR_dict['benchmark_flag']=self.benchmark_flag
        NR_dict['cooccurrence_top_list']=self.cooccurrence_top_list
        NR_dict['raw_nutrition_top_list']=self.raw_nutrition_top_list
        return(NR_dict)
        
class Recipe:
    def __init__(self, recipe_id, aver_rate, review_nums, spicy, recipe_name, 
    recipe_directions, recipe_ingredients, recipe_nutrition_result):
        self.recipe_id=int(recipe_id)
        self.aver_rate=float(aver_rate)
        self.review_nums=int(review_nums)
        self.spicy=int(spicy)
        self.recipe_name=recipe_name
        self.recipe_directions=recipe_directions
        self.recipe_ingredients=recipe_ingredients
        self.recipe_nutrition_result=recipe_nutrition_result
    
    def getDict(self):
        # return self as a dict
        recipe_dict={}
        recipe_dict['recipe_id']=self.recipe_id
        recipe_dict['aver_rate']=self.aver_rate
        recipe_dict['review_nums']=self.review_nums
        recipe_dict['spicy']=self.spicy
        recipe_dict['recipe_name']=self.recipe_name
        recipe_dict['recipe_directions']=self.recipe_directions
        recipe_dict['recipe_ingredients']=self.recipe_ingredients
        recipe_dict['recipe_nutrition_result']=self.recipe_nutrition_result
        return(recipe_dict)

class User_profile:
    def __init__(self, user_info):
        print(user_info)
        self.status=user_info['status']
        self.milk=user_info['milk']
        self.eggs=user_info['eggs']
        self.fish=user_info['fish']
        self.shellfish=user_info['shellfish']
        self.treenuts=user_info['treenuts']
        self.peanuts=user_info['peanuts']
        self.wheat=user_info['wheat']
        self.soybean=user_info['soybean']
        self.nonspicy=user_info['nonspicy']
        self.excludeIngredients=user_info['excludeIngredients']
        self.includeIngredients=user_info['includeIngredients']
        self.nutritionPriority=user_info['nutritionPriority']

class Nutrient_needs:
    def __init__(self, status):
        # set nutrient needs based on stage of pregnancy
        self.nutrients={}
        if status=='Pregnant - First Trimester':
            self.nutrients['Vitamin B6']=1.9
            self.nutrients['Folate']=600
            self.nutrients['Calcium']=1000
            self.nutrients['Iron']=27
            self.nutrients['Protein']=70
            self.nutrients['Vitamin A']=770
            self.nutrients['Vitamin C']=85
        elif status=='Pregnant - Second Trimester':
            self.nutrients['Vitamin B6']=1.9
            self.nutrients['Folate']=600
            self.nutrients['Calcium']=1000
            self.nutrients['Iron']=27
            self.nutrients['Protein']=80
            self.nutrients['Vitamin A']=770
            self.nutrients['Vitamin C']=85
        elif status=='Pregnant - Third Trimester':
            self.nutrients['Vitamin B6']=1.9
            self.nutrients['Folate']=600
            self.nutrients['Calcium']=1000
            self.nutrients['Iron']=27
            self.nutrients['Protein']=90
            self.nutrients['Vitamin A']=770
            self.nutrients['Vitamin C']=85
        elif status=='Lactating':
            self.nutrients['Vitamin B6']=2
            self.nutrients['Folate']=500
            self.nutrients['Calcium']=1000
            self.nutrients['Iron']=9
            self.nutrients['Protein']=70
            self.nutrients['Vitamin A']=1300
            self.nutrients['Vitamin C']=120
        else:
            self.nutrients['Vitamin B6']=1.7
            self.nutrients['Folate']=400
            self.nutrients['Calcium']=1000
            self.nutrients['Iron']=18
            self.nutrients['Protein']=50
            self.nutrients['Vitamin A']=770
            self.nutrients['Vitamin C']=60

def get_coIngredients(includeIngredients, s3Boto):
    co_ingr_list=[]
    co_ingr_dict={}
    for ingredient in includeIngredients:
        ingredient = ingredient[:-2]
        exp="SELECT * FROM s3object s where s.\"ingredient\" = \'" + ingredient + "\'"
        # print(exp)
        resp = s3Boto.select_object_content(
            Bucket='healthymamaeats.com',
            Key='co_ingredients_nutrition_v3.csv',
            ExpressionType='SQL',
            Expression=exp,
            InputSerialization = {'CSV': {"FileHeaderInfo": "Use"}, 'CompressionType': 'NONE'},
            OutputSerialization = {'CSV': {}},
            )
    
        for event in resp['Payload']:
            if 'Records' in event:
                records = event['Records']['Payload'].decode('utf-8')
                # print(records) 
                co_ingr_list = list(filter(None, records.split("\n")))
                # print(co_ingr_list)
                for record in co_ingr_list:
                    clean_record=record[:-1]
                    # print(clean_record)
                    fields=list(filter(None, clean_record.split(",")))
                    co_ingr_dict[fields[1]] = fields[2:]
                # print(co_ingr_dict)
    return co_ingr_dict

def get_best_coIngredients(co_ingrs_dict):
    # print(co_ingrs_dict)
    protein={}
    calcium={}
    iron={}
    vitA={}
    vitC={}
    vitB6={}
    folate={}
    best_ingr={}
    # print(co_ingrs_dict.keys())
    for ingr,nutrs in co_ingrs_dict.items():
        # print(ingr,nutrs)
        protein[ingr] = float(nutrs[0])
        calcium[ingr] = float(nutrs[1])
        iron[ingr] = float(nutrs[2])
        vitA[ingr] = float(nutrs[3])
        vitC[ingr] = float(nutrs[4])
        vitB6[ingr] = float(nutrs[5])
        folate[ingr] = float(nutrs[6])
    best_ingr['protein']=sorted(protein, key=protein.get, reverse=True)[:3]
    best_ingr['calcium']=sorted(calcium, key=calcium.get, reverse=True)[:3]
    best_ingr['iron']=sorted(iron, key=iron.get, reverse=True)[:3]
    best_ingr['vitA']=sorted(vitA, key=vitA.get, reverse=True)[:3]
    best_ingr['vitC']=sorted(vitC, key=vitC.get, reverse=True)[:3]
    best_ingr['vitB6']=sorted(vitB6, key=vitB6.get, reverse=True)[:3]
    best_ingr['folate']=sorted(folate, key=folate.get, reverse=True)[:3]
    # print(best_ingr)
    return best_ingr

def get_recipes(suzy, s3Boto):
    recipe_dict={}

    # whereClause = " WHERE core_ingredients LIKE '%chicken%' AND core_ingredients LIKE '%potato%' AND core_ingredients LIKE '%rosemary%' "
    # exp="SELECT recipe_id, recipe_name, ingredients, core_ingredients, Spicy, iron, calcium, folate, protein, vitaminA, vitaminB6, vitaminC, overall_trimester_1, overall_trimester_2, overall_trimester_3, overall_bf FROM s3object s WHERE core_ingredients LIKE '%chicken%' AND core_ingredients LIKE '%potato%' AND core_ingredients LIKE '%rosemary%' LIMIT 2"

    exp = build_sql(suzy)
    # exp = "SELECT recipe_id, recipe_name, ingredients, core_ingredients, Spicy, iron, calcium, folate, protein, vitaminA, vitaminB6, vitaminC, overall_trimester_1, overall_trimester_2, overall_trimester_3, overall_bf FROM s3object s WHERE  s.includeIngredients LIKE \%arugula\% AND  s.includeIngredients LIKE \%asparagus\% AND  s.includeIngredients LIKE %bamboo shoot% LIMIT 5"
    # 
    print(exp)
    resp = s3Boto.select_object_content(
        Bucket='healthymamaeats.com',
        Key='recipe_core_ingredients_defi_2.csv',
        ExpressionType='SQL',
        Expression=exp,
        InputSerialization = {'CSV': {"FileHeaderInfo": "Use"}, 'CompressionType': 'NONE'},
        OutputSerialization = {'CSV': {"FieldDelimiter": '\t'}},
        )

    for event in resp['Payload']:
        if 'Records' in event:
            records = event['Records']['Payload'].decode('utf-8')
            # print(records) 
            recipe_list = list(filter(None, records.split("\n")))
            # print(recipe_list)
            for recipe in recipe_list:
                # print(recipe)
                recipe_fields=list(filter(None, recipe.split('\t')))
                recipe_dict[recipe_fields[0]] = recipe_fields[1:]
            # print(recipe_dict)
    return recipe_dict

def get_best_recipes(suzy, recipe_dict):
    # print(recipe_dict)
    focus = suzy.nutritionPriority
    status = suzy.status
    
    # collect recipe ids and ranking metrics based on suzy's nutrition focus
    recipes = {}
    for recipe_id,recipe_data in recipe_dict.items():
        if focus=='Protein':
            recipes[recipe_id] = recipe_data[7]
        elif focus == 'Calcium':
               recipes[recipe_id] = recipe_data[5]
        elif focus == 'Iron':
               recipes[recipe_id] = recipe_data[4]
        elif focus == 'Overall':
            if status=='Pregnant - First Trimester':
               recipes[recipe_id] = recipe_data[11]
            elif status=='Pregnant - Second Trimester':
               recipes[recipe_id] = recipe_data[12]
            elif status=='Pregnant - Third Trimester':
               recipes[recipe_id] = recipe_data[13]
            else: 
                # status=='Lactating':
               recipes[recipe_id] = recipe_data[14]

    # get the top recipes for the metric selected
    top_ranked_recipes = dict(sorted(recipes.items(), key=lambda x: x[1], reverse=True)[:5])
    
    # get the full recipe dict entry for the top recipes
    return top_ranked_recipes

def get_recipe_directions(recipeIDList, s3Boto):
    exp="SELECT s.\"cooking_directions\" FROM s3object s where s.\"recipe_id\" = \'"
    for rID in recipeIDList:
        exp=exp+ rID + "\' OR s.\"recipe_id\" = \'"
    final_exp=exp[:len(exp)-21]
    print(final_exp)
    # print(exp)
    # print(final_exp)
    resp = s3Boto.select_object_content(
        Bucket='healthymamaeats.com',
        Key='recipe_directions.csv',
        ExpressionType='SQL',
        Expression=final_exp,
        InputSerialization = {'CSV': {"FileHeaderInfo": "Use"}, 'CompressionType': 'NONE'},
        OutputSerialization = {'CSV': {}},
        )

    for event in resp['Payload']:
        if 'Records' in event:
            records = event['Records']['Payload'].decode('utf-8')
            rDirs = list(filter(None, records.split("\n")))

    dir_list = []
    for dir in rDirs:
        dir_list.append(dir[18:-3])

    return dir_list
    
def build_sql(user_info):
    # exp = "SELECT recipe_id, recipe_name, ingredients, core_ingredients, Spicy, iron, calcium, folate, protein, vitaminA, vitaminB6, vitaminC, overall_trimester_1, overall_trimester_2, overall_trimester_3, overall_bf FROM s3object s WHERE "
    exp = "SELECT * FROM s3object s WHERE "
    if user_info.milk == 'TRUE':
        exp = exp + " Milk != 'TRUE' AND "
    if user_info.eggs == 'TRUE':
        exp = exp + " Eggs != 'TRUE' AND "
    if user_info.fish == 'TRUE':
        exp = exp + " Fish != 'TRUE' AND "
    if user_info.shellfish == 'TRUE':
        exp = exp + " Shell_fish != 'TRUE' AND "
    if user_info.wheat == 'TRUE':
        exp = exp + " Wheat != 'TRUE' AND "
    if user_info.peanuts == 'TRUE':
        exp = exp + " Peanuts != 'TRUE' AND "
    if user_info.treenuts == 'TRUE':
        exp = exp + " Tree_nuts != 'TRUE' AND "
    if user_info.soybean == 'TRUE':
        exp = exp + " Soybean != 'TRUE' AND "
    if user_info.nonspicy == 'TRUE':
        exp = exp + " Spicy != 'TRUE' AND "
    exp = exp + " s.core_ingredients LIKE '%" + user_info.includeIngredients[0][:-2] + "%' AND "
    exp = exp + " s.core_ingredients LIKE '%" + user_info.includeIngredients[1][:-2] + "%' AND "
    exp = exp + " s.core_ingredients LIKE '%" + user_info.includeIngredients[2][:-2] + "%' LIMIT 5"
    
    return exp

def lambda_handler(event, context): 
    # # 
    # # just checking LOL
    # # print(event)
    
    # create access object for s3 for co-ingredients
    s3 = boto3.client('s3')
    
    # read the user profile input
    # print("my event", event)
    suzy=User_profile(event)
    
    # get the best co-ongredients for the users include recommendations
    co_ingrs = get_coIngredients(suzy.includeIngredients,s3)
    # print(co_ingrs)
    top_co_ingrs = get_best_coIngredients(co_ingrs)
    
    # pull nutritional needs based on the users trimester/lactating
    nutrientsNeeded=Nutrient_needs(suzy.status)
    
    # pre-calculate user-specific nutrient data
    NR1=Nutrition_results("Vitamin B6", nutrientsNeeded.nutrients['Vitamin B6'], top_co_ingrs['vitB6'],benchmark_flag=0)
    NR2=Nutrition_results("Folate", nutrientsNeeded.nutrients['Folate'], top_co_ingrs['folate'], benchmark_flag=1)
    NR3=Nutrition_results("Calcium", nutrientsNeeded.nutrients['Calcium'], top_co_ingrs['calcium'], benchmark_flag=1)
    NR4=Nutrition_results("Iron", nutrientsNeeded.nutrients['Iron'], top_co_ingrs['iron'], benchmark_flag=1)
    NR5=Nutrition_results("Protein", nutrientsNeeded.nutrients['Protein'], top_co_ingrs['protein'], benchmark_flag=1)
    NR6=Nutrition_results("Vitamin A", nutrientsNeeded.nutrients['Vitamin A'], top_co_ingrs['vitA'], benchmark_flag=0)
    NR7=Nutrition_results("Vitamin C", nutrientsNeeded.nutrients['Vitamin C'], top_co_ingrs['vitC'],benchmark_flag=1)

    # add nutrient data to a list
    nutr_list=[NR1, NR2, NR3, NR4, NR5, NR6, NR7]
    
    # find the best recipes!!

    # create access object for s3 for recipe ingredient and nutrition data
    s3a = boto3.client('s3')
    # create access object for s3 for recipe instructions
    s3b = boto3.client('s3')
    
    #select an assortment of recipes for our user, suzy
    recipes = get_recipes(suzy,s3a)
    # pick the top ones
    print(recipes)
    top_recipes = get_best_recipes(suzy, recipes)

    # format those recipes for the app!!
    recipeList=[]
    nutIdx=[9,6,5,4,7,8,10]
    nrDictList=[]
    recipeIdList = list(recipes.keys())
    recipe_dirs = get_recipe_directions(recipeIdList, s3b)
    q=0
    for rId,rValues in recipes.items():
        nrDictList=[]
        rNutriList = copy.deepcopy(nutr_list)
        for i in range(7):
            # print(rNutriList[i])
            # print(rValues)
            rNutriList[i].amount=float(rValues[nutIdx[i]])
            rNutriList[i].benchmark_percentage=rNutriList[i].amount/rNutriList[i].benchmark
            if rNutriList[i].benchmark_percentage<.33:
                rNutriList[i].benchmark_flag=int(1)
            else:
                rNutriList[i].benchmark_flag=int(0)
            nrDictList.append(rNutriList[i].getDict())
        if rValues[3]=='TRUE':
            spicy=1
        else:
            spicy=0
        # inL=list(rValues[0].split(","))
        recipeObj=Recipe(rId, 4.0, 60, spicy, rValues[0],
        recipe_dirs[q], list(rValues[1].split(",")), nrDictList)
        q += 1
 
        recipeList.append(recipeObj.getDict())
    
    # create the json the app needs
    # recipes = format_recipes(top_recipes,nutr_list,s3b)

    # recipes = [recipe1.getDict(),recipe2.getDict()]
    # print(recipeList)
    # body = json.dumps(recipeList).replace("\\\\n","\n")
    # body2 = re.sub(r'\"',r'"',body)
    # print(body2)
    return {
        # 'statusCode': 200,
        'body': json.dumps(recipeList)
    }
