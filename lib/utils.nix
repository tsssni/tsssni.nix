{ lib }:
pkgs: rec {
	recursiveGetAttrWithJqPrefix =
		item: attr:
		let
			recurse =
				prefix: item:
				if item ? ${attr} then
				lib.nameValuePair prefix item.${attr}
				else if lib.isDerivation item then
				[ ]
				else if lib.isAttrs item then
				map (
					name:
					let
					escapedName = ''"${lib.replaceStrings [ ''"'' "\\" ] [ ''\"'' "\\\\" ] name}"'';
					in
					recurse (prefix + "." + escapedName) item.${name}
				) (lib.attrNames item)
				else if lib.isList item then
				lib.imap0 (index: item: recurse (prefix + "[${toString index}]") item) item
				else
				[ ];
		in lib.listToAttrs (lib.flatten (recurse "" item));

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
		+ lib.concatStringsSep "\n" (
		lib.imap1 (index: name: ''
			secret${toString index}=$(<'${secrets.${name}}')
			export secret${toString index}
		'') (lib.attrNames secrets)
		)
		+ "\n"
		+ "${pkgs.jq}/bin/jq >'${output}' "
		+ lib.escapeShellArg (
		stringOrDefault (lib.concatStringsSep " | " (
			lib.imap1 (index: name: ''${name} = $ENV.secret${toString index}'') (lib.attrNames secrets)
		)) "."
		)
		+ ''
<<'EOF'
			${builtins.toJSON set}
EOF
			(( ! $inherit_errexit_enabled )) && shopt -u inherit_errexit
		'';
}
