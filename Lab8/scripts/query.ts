import { MusicCatalog } from "../utils/MusicCatalog";
import { dataMapper } from "../utils/DataMapper";

testQuery('Anemiel Biamandros1', 'Rimesion Shimondo', 2021);


async function testQuery(artist: string, album: string, year: number) {
    console.log('RESULTS:')

    console.log('\nQuery by artist')
    await queryByArtist(artist)
    console.log('------------------------------')

    console.log('\nQuery by album')
    await queryByAlbum(album)
    console.log('------------------------------')

    console.log('\nQuery by albumReleaseYear')
    await queryByAlbumReleaseYear(year)
    console.log('------------------------------')
}

async function queryByArtist(artist: string) {
    for await (const result of dataMapper.query(MusicCatalog, { "artist": artist }, { indexName: "artist_songId" })) {
        console.log(result)
    }
}

async function queryByAlbum(album: string) {
    for await (const result of dataMapper.query(MusicCatalog, { "album": album }, { indexName: "album_songId" })) {
        console.log(result)
    }
}

async function queryByAlbumReleaseYear(year: number) {
    for await (const result of dataMapper.query(MusicCatalog, { "albumReleaseYear": year }, { indexName: "albumReleaseYear_songId" })) {
        console.log(result)
    }
}
