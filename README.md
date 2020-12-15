# ldfolder

folder dynamics.

## Usage

include required js and css file, then:

    # initialization
    folder = new ldfolder({root: '<root-of-some-ldfd-tree>'});

    # manually toggle 'some-subnode' on.
    folder.toggle('some-subnode', true);


## Sample ldfd structure

    .ldfd
      .ldfd-item
      .ldfd
        .ldfd-item.ldfd-toggle
        .ldfd-menu
          .ldfd-item
          .ldfd-item


## License

MIT
