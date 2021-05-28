import * as cdk from '@aws-cdk/core';
import {
  AttributeType,
  Attribute,
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

    this.addIndex(table, {
      name: MusicCatalogTable.artist,
      type: AttributeType.STRING
    }, {
      name: MusicCatalogTable.songId,
      type: AttributeType.STRING
    }, "artist_songId");

    this.addIndex(table, {
      name: MusicCatalogTable.album,
      type: AttributeType.STRING
    }, {
      name: MusicCatalogTable.songId,
      type: AttributeType.STRING
    }, "album_songId");

    this.addIndex(table, {
      name: MusicCatalogTable.albumReleaseYear,
      type: AttributeType.NUMBER
    }, {
      name: MusicCatalogTable.songId,
      type: AttributeType.STRING
    }, "albumReleaseYear_songId");
  }

  private addIndex(table: Table, partitionKey: Attribute, sortKey: Attribute, indexName: string) {
    table.addGlobalSecondaryIndex({
      partitionKey,
      sortKey,
      indexName,
    });
  }
}
