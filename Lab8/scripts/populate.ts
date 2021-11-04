import { nameByRace } from "fantasy-name-generator";

import { MusicGenres } from "../constants/MusicGenres";
import { DataConfig } from "../constants/DataConfig";
import { MusicCatalog } from "../utils/MusicCatalog";
import { dataMapper } from "../utils/DataMapper";

populate();


async function populate() {
    for (const genre in MusicGenres) {
        console.log(`[${genre}] processing...`);
        await populateArtists(genre);
    }
}

async function populateArtists(genre: string) {
    let count = 0;
    for (let i = 0; i < DataConfig.artists; i++) {
        const artist = nameByRace("elf", { gender: "female", allowMultipleNames: true })
            + ' ' + nameByRace("dragon", { gender: "male", allowMultipleNames: true }) + `${i}`;
        const dbEntryList = Array.from(populateAlbums(genre, artist as string));

        for await (const persisted of dataMapper.batchPut(dbEntryList)) {
            // console.log(persisted);
            count += 1;
        }
    }
    console.log(count);
}

function* populateAlbums(genre: string, artist: string) {
    for (let i = 0; i < DataConfig.albums; i++) {
        const album = nameByRace("elf", { gender: "male", allowMultipleNames: false })
            + ' ' + nameByRace("fairy", { gender: "male", allowMultipleNames: true });

        for (const obj of getSongs(genre, artist, album as string))
            yield obj
    }
}

function* getSongs(genre: string, artist: string, album: string) {
    for (let i = 0; i < DataConfig.songs; i++) {
        const albumReleaseYear = Math.floor(2000 + Math.random() * 22);
        const songDuration = Math.floor((Math.random() * 200 + 50));
        const song = nameByRace("elf", { gender: "female", allowMultipleNames: true })
            + ' ' + nameByRace("angel", { gender: "female", allowMultipleNames: true });

        const songRecord = MusicCatalog.create({
            genre: genre,
            artist: artist,
            album: album,
            song: song as string,
            albumReleaseYear: albumReleaseYear,
            songDuration: songDuration,
            songNumber: (i + 1),
        })

        yield songRecord;
    }
}
