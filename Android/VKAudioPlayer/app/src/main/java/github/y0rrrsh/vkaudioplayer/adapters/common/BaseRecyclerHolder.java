package github.y0rrrsh.vkaudioplayer.adapters.common;

import android.support.v7.widget.RecyclerView;
import android.view.View;

import butterknife.ButterKnife;

/**
 * @author Artur Yorsh
 */
public class BaseRecyclerHolder extends RecyclerView.ViewHolder {

    public BaseRecyclerHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }
}
