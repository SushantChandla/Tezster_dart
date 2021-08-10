import 'dart:convert';

dynamic sortData(f) {
  return (node) {
    return (a, b) {
      var aobj = {'key': a, 'value': node[a]};
      var bobj = {'key': b, 'value': node[b]};
      return f(aobj, bobj);
    };
  };
}

String jsonStringify(dat, {opts}) {
  if (opts == null) opts = {};
  if (opts.runtimeType == Function) opts = {'cmp': opts};

  var cycles = (opts.cycles.runtimeType == bool) ? opts.cycles : false;

  bool cmp = opts['cmp'] != null;

  var seen = [];

  stringify(node) {
    if (node != null && jsonEncode(node) != null && node.toJSON is Function) {
      node = node.toJSON();
    }

    if (node == null) return;
    if (node.runtimeType == int) return node.isFinite ? '' + node : 'null';
    if (!node is Map) return JsonEncoder().convert(node);

    var i, out;
    if (node.runtimeType == List) {
      out = '[';
      for (i = 0; i < node.length; i++) {
        if (i) out += ',';
        out += stringify(node[i]) || null;
      }
      return out + ']';
    }

    if (node == null) return null;

    if (seen.indexOf(node) != -1) {
      if (cycles) return jsonEncode('__cycle__');
      throw new Exception('Converting circular structure to JSON');
    }
    seen.add(node);
    var seenIndex = seen.length - 1;
    var keys = node.keys.toList();
    keys.sort(cmp != null && sortData(node));

    keys.sort((a, b) {
      return opts.cmp != null && a.compareTo(b);
    });

    out = '';
    for (i = 0; i < keys.length; i++) {
      var key = keys[i];
      var value = stringify(node[key]);

      if (!value) continue;
      if (out) out += ',';
      out += JsonEncoder().convert(key) + ':' + value;
    }
    seen.sublist(seenIndex, 1);
    return '{' + out + '}';
  }

  return stringify(dat);
}
