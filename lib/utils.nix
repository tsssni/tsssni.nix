{ lib }:
pkgs: with lib; rec {
	recursiveGetAttrWithJqPrefix =
		item: attr:
		let
			recurse =
				prefix: item:
				if item ? ${attr} then
				nameValuePair prefix item.${attr}
				else if isDerivation item then
				[ ]
				else if isAttrs item then
				map (
					name:
					let
					escapedName = ''"${replaceStrings [ ''"'' "\\" ] [ ''\"'' "\\\\" ] name}"'';
					in
					recurse (prefix + "." + escapedName) item.${name}
				) (attrNames item)
				else if isList item then
				imap0 (index: item: recurse (prefix + "[${toString index}]") item) item
				else
				[ ];
		in listToAttrs (flatten (recurse "" item));

	genJqSecretsReplacementSnippet = genJqSecretsReplacementSnippet' "_secret";

	genJqSecretsReplacementSnippet' =
		attr: set: output:
		let
			secrets = recursiveGetAttrWithJqPrefix set attr;
			stringOrDefault = str: def: if str == "" then def else str;
		in ''
			if [[ -h '${output}' ]]; then
				rm '${output}'
			fi

			inherit_errexit_enabled=0
			shopt -pq inherit_errexit && inherit_errexit_enabled=1
			shopt -s inherit_errexit
		''
		+ concatStringsSep "\n" (
		imap1 (index: name: ''
			secret${toString index}=$(<'${secrets.${name}}')
			export secret${toString index}
		'') (attrNames secrets)
		)
		+ "\n"
		+ "${pkgs.jq}/bin/jq >'${output}' "
		+ lib.escapeShellArg (
		stringOrDefault (concatStringsSep " | " (
			imap1 (index: name: ''${name} = $ENV.secret${toString index}'') (attrNames secrets)
		)) "."
		)
		+ ''
<<'EOF'
			${builtins.toJSON set}
EOF
			(( ! $inherit_errexit_enabled )) && shopt -u inherit_errexit
		'';
}
