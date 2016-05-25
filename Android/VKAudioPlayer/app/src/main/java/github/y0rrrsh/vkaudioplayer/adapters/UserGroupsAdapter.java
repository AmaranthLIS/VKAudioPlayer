package github.y0rrrsh.vkaudioplayer.adapters;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import butterknife.BindView;
import github.y0rrrsh.vkaudioplayer.R;
import github.y0rrrsh.vkaudioplayer.activities.ListAudioActivity;
import github.y0rrrsh.vkaudioplayer.adapters.common.VkItemAdapter;
import github.y0rrrsh.vkaudioplayer.adapters.common.VkItemHolder;
import github.y0rrrsh.vkaudioplayer.models.Group;

/**
 * @author Artur Yorsh
 */
public class UserGroupsAdapter extends VkItemAdapter<Group, UserGroupsAdapter.GroupHolder> {

    @Override
    protected int getItemViewResId() {
        return R.layout.item_group;
    }

    @Override
    protected GroupHolder onCreateViewHolder(View itemView, int viewType) {
        return new GroupHolder(itemView);
    }

    @Override
    protected void onBindViewHolder(GroupHolder holder, Group item, int position) {
        Picasso.with(holder.itemView.getContext()).load(item.getPhoto200()).into(holder.imageAvatar);
        holder.textTitle.setText(item.getName());

        holder.itemView.setOnClickListener(v ->
                ListAudioActivity.start(holder.itemView.getContext(), -item.getId(), item.getName()));
    }

    static class GroupHolder extends VkItemHolder {

        @BindView(R.id.text_group_title) TextView textTitle;
        @BindView(R.id.image_group_avatar) ImageView imageAvatar;

        public GroupHolder(View itemView) {
            super(itemView);
        }
    }
}
