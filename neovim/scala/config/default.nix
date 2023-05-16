{
  buildConfig = { jdk, metals }: ''
    ${builtins.readFile ./metals.lua}
    metals_setup("${jdk}", "${metals}/bin/metals")
  '';
}
