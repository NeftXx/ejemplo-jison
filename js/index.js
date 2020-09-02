function analizar() {
  var entrada = document.getElementById("editor").value;
  var salida = analizador.parse(entrada);
  console.log(salida);
  document.getElementById("consola").value = salida;
}
