import * as cdk from '@aws-cdk/core';
import {
  AttributeType,
  BillingMode,
  Table,
} from "@aws-cdk/aws-dynamodb";

import { MusicCatalogTable } from '../constants/MusicCatalogTable';


export class Lab8Stack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const table = new Table(this, MusicCatalogTable.tableName, {
      tableName: MusicCatalogTable.tableName,
      partitionKey: {
        name: MusicCatalogTable.partitionKey,
        type: AttributeType.STRING
      },
      sortKey: {
        name: MusicCatalogTable.songId,
        type: AttributeType.STRING
      },

      removalPolicy: cdk.RemovalPolicy.DESTROY,
      billingMode: BillingMode.PAY_PER_REQUEST,
    });

    table.addGlobalSecondaryIndex({
      partitionKey: {
        name: MusicCatalogTable.artist,
        type: AttributeType.STRING
      },
      sortKey: {
        name: MusicCatalogTable.songId,
        type: AttributeType.STRING
      },
      indexName: "artist_songId"
    });

    table.addGlobalSecondaryIndex({
      partitionKey: {
        name: MusicCatalogTable.album,
        type: AttributeType.STRING
      },
      sortKey: {
        name: MusicCatalogTable.songId,
        type: AttributeType.STRING
      },
      indexName: "album_songId"
    });

    table.addGlobalSecondaryIndex({
      partitionKey: {
        name: MusicCatalogTable.albumReleaseYear,
        type: AttributeType.NUMBER
      },
      sortKey: {
        name: MusicCatalogTable.songId,
        type: AttributeType.STRING
      },
      indexName: "albumReleaseYear_songId"
    });
  }
}
