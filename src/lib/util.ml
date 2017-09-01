open Common


let common_opam_pins =
  let open Configuration_dot_env in
  object
    method configuration = [
      env "pin_ketrew"
        ~help:"Pin Ketrew to a given branch/tag.";
      env "pin_coclobas"
        ~help:"Pin Coclobas to a given branch/tag.";
      env "pin_biokepi"
        ~help:"Pin Biokepi to a given branch/tag.";
      env "pin_trakeva"
        ~help:"Pin Trakeva to a given branch/tag.";
    ]
    method opam_pins configuration =
      let conf_opt n = Configuration_dot_env.get_exn configuration n in
      let pin_opt repo o =
        Option.map o ~f:(fun branch ->
            Opam.Pin.make (Filename.basename repo)
              ~pin:(sprintf "https://github.com/%s.git#%s" repo branch)) in
      List.filter_opt [
        pin_opt "hammerlab/ketrew" @@ conf_opt "pin_ketrew";
        pin_opt "hammerlab/coclobas" @@ conf_opt "pin_coclobas";
        pin_opt "eric-czech/biokepi" @@ conf_opt "pin_biokepi";
        pin_opt "smondet/trakeva" @@ conf_opt "pin_trakeva";
      ]
  end

let nfs_mounts_configuration () =
  let open Configuration_dot_env in
  env "nfs_mounts"
    ~example:"my-nfs-server-01-vm,/nfs-pool,.tmp/witness,/nfs01:\n\
              nfs-42-vm,/nfs-pool,local/path/some/file,/nfs42"
    ~help:"List of additional NFS servers to mount on the Ketrew server \n\
           and on Coclobas' jobs.\n\
           It is a colon-separated list of NFS mounts, and each mount is a \
           comma-separated tuple:\n\
           <server-hostname>,<server-side-storage-path>,<witness-file>,<mount-point>"

let coclobas_docker_image =
  let open Configuration_dot_env in
  object
    method configuration =
      env "coclobas_docker_image" ~required:false
        ~help:"Override the default Docker image to use for the Ketrew \
               and Coclobas services.";
    method get configuration =
      get_exn configuration "coclobas_docker_image"
  end