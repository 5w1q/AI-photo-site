	// 渲染图片的函数
	function renderImage(item) {
	    if (item.type === 'image') {
	        const imageContainer = document.createElement('div');
	        imageContainer.className = 'image-container';
	        const img = document.createElement('img');
	        img.src = item.src;
	        img.alt = item.alt;
	        imageContainer.appendChild(img);
	        // 如果有caption，添加说明文字
	        if (item.caption) {
	            const caption = document.createElement('div');
	            caption.className = 'image-caption';
	            caption.textContent = item.caption;
	            imageContainer.appendChild(caption);
	        }
	        return imageContainer;
	    }
	    return null;
	}