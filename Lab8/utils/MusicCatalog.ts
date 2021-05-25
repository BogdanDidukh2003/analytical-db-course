import {
    attribute,
    hashKey,
    rangeKey,
    table
} from "@aws/dynamodb-data-mapper-annotations";
import * as shortUUID from "short-uuid";

import { MusicCatalogTable } from "../constants/MusicCatalogTable";


export interface IMusicCatalog {
    genre: string,
    artist: string,
    album: string,
    song: string,
    albumReleaseYear: number,
    songDuration: number,
    songNumber: number,
}


@table(MusicCatalogTable.tableName)
export class MusicCatalog implements IMusicCatalog {

    static getPartitionKey(obj: Partial<IMusicCatalog>): string {
        return `${obj.genre}_${obj.artist}_${obj.album}`;
    }

    static create(data: IMusicCatalog): MusicCatalog {
        const result = new MusicCatalog();
        Object.assign(result, data);
        result.partitionKey = this.getPartitionKey(data);
        result.songId = shortUUID.generate();
        return result;
    }

    constructor() { }

    @hashKey({
        attributeName: MusicCatalogTable.partitionKey,
        attributeType: "S",
    })
    partitionKey: string;

    @attribute({ attributeName: MusicCatalogTable.genre })
    genre: string;

    @attribute({
        attributeName: MusicCatalogTable.artist
    })
    artist: string;

    @attribute({ attributeName: MusicCatalogTable.album })
    album: string;

    @rangeKey({ attributeName: MusicCatalogTable.songId })
    songId: string;

    @attribute({ attributeName: MusicCatalogTable.song })
    song: string;

    @attribute({ attributeName: MusicCatalogTable.albumReleaseYear })
    albumReleaseYear: number;

    @attribute({ attributeName: MusicCatalogTable.songDuration })
    songDuration: number;

    @attribute({ attributeName: MusicCatalogTable.songNumber })
    songNumber: number;
}
