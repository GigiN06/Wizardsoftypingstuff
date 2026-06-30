extends RichTextLabel

var incantations = {}
var vocab = {}
var recent_words={"nouns":[],"verbs":[],"adjectives":[]}
var paragraph=[]

func weighted_choice(items: Array, weights: Array):
	if items.is_empty():
		return null
	if items.size() != weights.size():
		push_error("Items and weights size mismatch")
		return null
	var total := 0.0
	for w in weights:
		total += w
	if total <= 0:
		return items.pick_random()
	var roll := randf() * total
	var current := 0.0
	for i in range(items.size()):
		current += weights[i]
		if roll < current:
			return items[i]
	return items.back()

func validate_tags(template: String) -> Array:
	var regex := RegEx.new()
	regex.compile("\\[(.*?)\\]")
	var matches := regex.search_all(template)
	var results := []
	for match in matches:
		results.append(match.get_string(1))
	return results
	
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a=0.5
	randomize()
	incantations=load_json("res://json/text/incantations.json")
	vocab=load_json("res://json/text/vocab.json")
	generate()
	
	
	
func generate():
	paragraph=[]
	for i in range(3):
		paragraph.append(get_incantation())
	text = "\n".join(paragraph)
	

func load_json(path:String):
	var file=FileAccess.open(path,FileAccess.READ)
	var texts=file.get_as_text()
	
	var json=JSON.new()
	var error=json.parse(texts)
	
	if error!=OK:
		push_error("Failed to parse %s" % path)
		return {}
	return json.data
		

func update_word(type,word):
	recent_words[type].append(word)
	if recent_words[type].size()>15:
		recent_words[type].remove_at(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func wordgen(placeholder):
	placeholder=placeholder.strip_edges()
	var pool=[]
	var word_type:=""
	if placeholder.contains("Nouns"): word_type="nouns"
	elif placeholder.contains("Verbs"): word_type="verbs"
	elif placeholder.contains("Adjectives"): word_type="adjectives"
	else: word_type="grammar"
	var categories=incantations.get("word_categories",{})
	if categories.has(placeholder):pool=categories[placeholder]
	else:pool=incantations.get("word_categories",{}).get("Nouns",[])
	var word=pool.pick_random()
	var words=vocab.get(word_type,{}).get(word,[])
	if word_type=="grammar":
		return words.pick_random()
	else:
		var weights=[]
		for item in words:
			if recent_words[word_type].has(item):
				weights.append(1)
			else: weights.append(3)
		word=weighted_choice(words,weights)
		update_word(word_type,word)
	return word
		
	
func sentencegen(template):
	var word_cat=incantations.get("word_categories",{})
	var placeholders=validate_tags(template)
	for placeholder in placeholders:
		if !word_cat.has(placeholder):
			push_error("Unknown placeholder: " + placeholder)
			return ""
		var tag = "[" + placeholder + "]"
		var replacement = wordgen(placeholder)
		var index = template.find(tag)
		if index != -1:
			template = template.substr(0, index) + replacement + template.substr(index + tag.length())
	return template
	
func get_incantation():
	var sentence_types=incantations.get("sentence_types",{})
	var weights=[]
	var names=[]
	for sentence_type in sentence_types:
		var weight=sentence_types[sentence_type].get("weight",1)
		weights.append(weight)
		names.append(sentence_type)
	var choose_type=weighted_choice(names,weights)
	var templates=sentence_types[choose_type].get("templates",[])
	if templates.is_empty():
		return ""
	var template = templates.pick_random()
	template = sentencegen(template)
	template = template.left(1).to_upper() + template.substr(1)
	return template
