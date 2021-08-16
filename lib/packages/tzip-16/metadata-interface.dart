 
 Map ViewImplementationType= {
	'MICHELSON_STORAGE':'michelsonStorageView',
	'REST_API_QUERY' :'restApiQuery'
};


class MetadataInterface {
	String name;
  String	description ;
	String version;
	dynamic license;
	dynamic authors;
	dynamic homepage;
	dynamic source;
	List<String> interfaces;
	dynamic errors;
	List<ViewDefinition> views;
}

class ViewDefinition {
	String name;
	String description;
	List<dynamic> implementations;
 	bool pure;
}