Document
	= elements:Element+

Element
	= name:ElementName _ body:ElementBody _ {
		let o = body;
		o.element = name;
		return o;
	}

ElementName "element name"
	= id:[a-zA-Z0-9_]+ { return id.join("") }

ElementBody
	= "{" _
	body:(ElementItem)*
	"}" {
		return body.reduce((f, t) => {
			if (t.children) {
				f.children = f.children.concat(t.children);
			}
			if (t.attributes) {
				for (let a in t.attributes) {
					f.attributes[a] = t.attributes[a];
				}
			}
			return f;
		}, {"attributes": {}, "children": []});
	}

ElementItem
	= attr:AttributeDefinition {
			let o = {attributes: {}};
			o.attributes[attr[0]] = attr[1];
			return o;
		} /
		child:Element {
			return {"children": [child]};
		}

AttributeDefinition "attribute"
	= key:AttributeName ":" _
		value:Value _ { return [key, value] }

AttributeName "attribute name"
	= id:[a-zA-Z0-9_]+ { return id.join("") }

Value
	= Number / Bool / String

Number "number"
	= digits:[0-9\.]+ { return parseFloat(digits.join(""))}

String "string"
	= quotation_mark chars:char* quotation_mark { return chars.join(""); }
char
	= unescaped
	/ escape
		sequence:(
			'"'
			/ "\\"
			/ "/"
			/ "b" { return "\b"; }
			/ "f" { return "\f"; }
			/ "n" { return "\n"; }
			/ "r" { return "\r"; }
			/ "t" { return "\t"; }
			/ "u" digits:$(HEXDIG HEXDIG HEXDIG HEXDIG) {
				return String.fromCharCode(parseInt(digits, 16));
			}
		)
		{ return sequence; }
escape
	= "\\"
quotation_mark
	= '"'
unescaped
	= [^\0-\x1F\x22\x5C]
HEXDIG = [0-9a-f]i

Bool "bool"
	= "true" / "false"

_ "whitespace"
	= ([ \t\n\r] / Comment)* 

Comment
	= ([#;!] / "//" / "--") [^\n\r]*

