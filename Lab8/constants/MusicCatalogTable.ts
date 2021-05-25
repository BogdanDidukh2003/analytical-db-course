export class MusicCatalogTable {

    static readonly tableName = "MusicCatalog";

    static readonly partitionKey = "genre_artist_album";
    static readonly songId = "songId";

    static readonly genre = "genre";
    static readonly artist = "artist";
    static readonly album = "album";
    static readonly song = "song";

    static readonly albumReleaseYear = "albumReleaseYear";
    static readonly songDuration = "songDuration";
    static readonly songNumber = "songNumber";
}
