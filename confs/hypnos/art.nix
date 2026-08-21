{...}: {
  services.caddy.virtualHosts."caw.unw.re" = {
    logFormat = "output discard";
    extraConfig = ''
      respond <<EOF
                 ¸¸   /:       *caw*
                { · >/
           _.-¨_¨_ )O    *caw*
        ,~`  ____.~                       *caw*
      ~`- `¨ //                 *caw*
             ¨¨

      EOF
    '';
  };
}
