{
pkgs,
...
}:
with pkgs;
beamPackages.mixRelease rec {
  pname = "hello_world";
  version = "0.0.1";

  src = ./.;

  # possible to include deps from mix.exs with these lines
  # mixFodDeps = beamPackages.fetchMixDeps {
  #   inherit pname version src;

  #   hash = "sha256-1ihxPfdLPr5jWFfcX2tccFUl7ND1mi9u8Dn28k6lGVA=";
  # };

  installPhase = ''
    runHook preInstall
    mkdir -p $out

    MIX_BUILD_PATH=$out mix do compile --no-deps-check

    runHook postInstall
  '';


  meta = with lib; {
    description = "Helloworld just do a mix compile and make the result available in nix store for hot code loading";
    homepage = "https://example.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ samrose ];
    mainProgram = "lexical";
    platforms = beamPackages.erlang.meta.platforms;
  };
}
