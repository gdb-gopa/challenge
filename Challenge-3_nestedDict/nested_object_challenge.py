import ast

def nested_value(input_dict, nested_key):
    internal_dict_value = input_dict
    internal_key = nested_key.split("/")
    for k in internal_key:
        internal_dict_value = internal_dict_value.get(k, None)
        if internal_dict_value is None:
            return internal_dict_value
    return internal_dict_value

input1 = ast.literal_eval(input("Enter the Object : "))
input2 = input("Enter the Key : ")
print(nested_value(input1, input2))