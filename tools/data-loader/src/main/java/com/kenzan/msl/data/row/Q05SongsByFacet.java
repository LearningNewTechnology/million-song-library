package com.kenzan.msl.data.row;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.kenzan.msl.data.ContentType;
import com.kenzan.msl.data.NormalizedRow;

public class Q05SongsByFacet {

    private final String facetName;
    private final ContentType contentType = ContentType.SONG;
    private final String songName;
    private final UUID songId;
    private final UUID albumId;
    private final String albumName;
    private final int albumYear;
    private final UUID aritstId;
    private final UUID artistMbid;
    private final String artistName;
    private final int songDuration;
    
    public Q05SongsByFacet(final NormalizedRow normalizedRow, final String facetName) {

        this.facetName = facetName;
        this.songName = normalizedRow.getSong().getName();
        this.songId = normalizedRow.getSong().getId();
        this.albumId = normalizedRow.getAlbum().getId();
        this.albumName = normalizedRow.getAlbum().getName();
        this.albumYear = normalizedRow.getAlbum().getYear();
        this.aritstId = normalizedRow.getArtist().getId();
        this.artistMbid = normalizedRow.getArtist().getMbid();
        this.artistName = normalizedRow.getArtist().getName();
        this.songDuration = normalizedRow.getSong().getDuration();
    }
    
    public String toString() {
        
        final List<String> row = new ArrayList<String>();
        row.add(facetName);
        row.add(contentType.toString());
        row.add(RowUtil.formatText(songName));
        row.add(songId.toString());
        row.add(albumId.toString());
        row.add(RowUtil.formatText(albumName));
        row.add(RowUtil.formatInt(albumYear));
        row.add(aritstId.toString());
        row.add(artistMbid.toString());
        row.add(RowUtil.formatText(artistName));
        row.add(RowUtil.formatInt(songDuration));
        return String.join(RowUtil.FIELD_DELIMITER, row);
    }
}
